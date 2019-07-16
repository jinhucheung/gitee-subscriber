class LogsController < ApplicationController
  set :views, File.join(settings.root, 'app/views/logs')

  helpers do
    class << self
      def deploy_header_xpath_expression
        @deploy_header_xpath_expression ||= begin
          header_exps = header_tags.map {|header| "self::#{header}"}.join(' or ')
          token_exps  = settings.pull_request_deploy_tokens.map {|token| "text()='#{token}'"}.join(' or ')

          "//*[#{header_exps}][#{token_exps}]".freeze
        end
      end

      def header_tags
        @header_tags ||= %w[h1 h2 h3 h4 h5 h6].freeze
      end
    end

    def actual_request?
      settings.development? || 'true' != env['HTTP_X_GITEE_PING']
    end

    def merged_pull_request_event?
      'Merge Request Hook' == env['HTTP_X_GITEE_EVENT'] && 'merge' == params[:action]
    end

    def extract_deploy_section(body)
      return if body.blank?

      marked_body = CommonMarker.render_html(body, %i[GITHUB_PRE_LANG UNSAFE], %i[tagfilter autolink table strikethrough])
      parsed_body = Nokogiri::HTML(marked_body)

      deploy_header = parsed_body.at_xpath(self.class.deploy_header_xpath_expression)
      return if deploy_header.blank?

      section_nodes = []
      deploy_header_index = self.class.header_tags.index(deploy_header.name).to_i
      node = deploy_header.next

      while node
        node_index = self.class.header_tags.index(node.name).to_i

        break unless node_index.zero? || node_index > deploy_header_index

        section_nodes << node
        node = node.next
      end

      section_nodes.map(&:to_s).join
    end
  end

  before do
    halt 401, 'Not authorized' unless [env['HTTP_X_GITEE_TOKEN'], params[:access_token], cookies[:access_token]].include?(settings.access_token)
  end

  get '/' do
    cookies[:access_token] = settings.access_token

    @logs = 'yesterday' == params[:scope] ? Log.yesterday : Log.today
    @logs = @logs.recent

    erb :index
  end

  post '/' do
    begin
      halt 200 unless actual_request? && merged_pull_request_event?

      log = Log.create(
        type: 'PullRequestLog',
        ident: params[:pull_request][:number],
        url: params[:pull_request][:html_url],
        title: params[:pull_request][:title],
        summary: extract_deploy_section(params[:pull_request][:body]),
        actor_name: params[:sender][:name],
        actor_url: params[:sender][:html_url],
        author_name: params[:author][:name],
        author_url: params[:author][:html_url]
      )

      raise log.errors.full_messages.join('\n') unless log.persisted?

      halt 200, "generated log #{log.id}"
    rescue => e
      halt 400, e.message
    end
  end
end