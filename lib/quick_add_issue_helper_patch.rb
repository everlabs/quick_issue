require 'projects_helper'

module QuickAddIssueHelperPatch
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      alias_method_chain :render_project_hierarchy, :add_issue
    end
  end

  module InstanceMethods
    def render_project_hierarchy_with_add_issue(projects)
      render_project_nested_lists(projects) do |project|
        s = link_to_project(project, {}, :class => "#{project.css_classes} #{User.current.member_of?(project) ? 'my-project' : nil}")
        s << link_to('(add)', new_project_issue_path(project), :style => 'margin-left: 5px;')
        if project.description?
          s << content_tag('div', textilizable(project.short_description, :project => project), :class => 'wiki description')
        end
        s
      end
    end
  end
end

ProjectsHelper.send(:include, QuickAddIssueHelperPatch)
