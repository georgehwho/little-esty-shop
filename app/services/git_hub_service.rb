class GitHubService
    def initialize(token)
      @token = token
    end

    def conn
      Faraday.new(
        url: 'https://api.github.com',
        headers: {
          'Authorization' => "token #{@token}",
          'Accept' => 'application/vnd.github.v3+json'
        }
      )
    end

    def commits_by_author(commits, author)
      commits.find do |data|
        data[:author][:login] == author
      end[:total]
    end

    def get_commits
      resp = conn.get('/repos/georgehwho/little-esty-shop/stats/contributors', {
        owner: 'georgehwho',
        repo: 'little-esty-shop'
      })
      JSON.parse(resp.body, symbolize_names: true)
    end

    def get_collaborators
      resp = conn.get('/repos/georgehwho/little-esty-shop/collaborators')
      JSON.parse(resp.body, symbolize_names: true)
    end

    def get_pull_requests
      resp = conn.get('/repos/georgehwho/little-esty-shop/pulls', {
        owner: 'georgehwho',
        repo: 'little-esty-shop',
        state: 'closed',
        sort: 'is merged'
        })
        json = JSON.parse(resp.body, symbolize_names: true)
        json.select { |pr| pr[:merged_at] }
    end

    def get_repo_name
      resp = conn.get('/repos/georgehwho/little-esty-shop')
      json = JSON.parse(resp.body, symbolize_names: true)
      json[:name]
    end
  end
