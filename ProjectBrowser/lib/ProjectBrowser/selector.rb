module ProjectBrowser
  class Selector

    attr_reader :current_project_index,
                :all_projects

    # @param [Array<ProjectBrowser::Project>] all_projects
    def initialize(all_projects)
      @all_projects = all_projects
      @current_project_index = 0
    end

    def next_project
      @current_project_index += 1
      if (@all_projects.length - 1) <= @current_project_index
        @current_project_index = @all_projects.length - 1
      end
    end

    def previous_project
      @current_project_index -= 1
      if @current_project_index < 0
        @current_project_index = 0
      end
    end

    # @return [ProjectBrowser::Project]
    def current_project
      @all_projects[@current_project_index]
    end

  end
end