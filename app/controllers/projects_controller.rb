class ProjectsController < ApplicationController
  # before_action :set_project, only: [:show, :update, :delete]

  class_iam_policy(
      {
          action: ["dynamodb:*"],
          effect: "Allow",
          resource: [
            "arn:aws:dynamodb:::global-table/inv8-prod-projects",
            "arn:aws:dynamodb:::global-table/inv8-prod-projects/*"
          ]
      }
  )
  before_action :set_project, only: [:build_id]

  layout false

  # GET /projects/name
  def build_id
    @build_id = @project.attrs['build_id'].to_i
    @project.attrs(build_id: @build_id + 1 )
    @project.replace
    # render json: {build_id: build_id}
    render inline: "<%= @build_id %>"
  end

  # GET /projects
  # def index
  #   @projects = Project.all
  #
  #   render json: @projects
  # end

  # GET /projects/1
  # def show
  #   render json: @project
  # end

  # POST /projects
  # def create
  #   @project = Project.new(project_params)
  #
  #   if @project.save
  #     render json: @project, status: :created
  #   else
  #     render json: @project.errors, status: :unprocessable_entity
  #   end
  # end

  # PATCH/PUT /projects/1
  # def update
  #   if @project.update(project_params)
  #     render json: @project
  #   else
  #     render json: @project.errors, status: :unprocessable_entity
  #   end
  # end

  # DELETE /projects/1
  # def delete
  #   @project.destroy
  #   render json: {deleted: true}
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project
      unless @project = Project.find(params[:name])
        # create initial project record
        @project = Project.new(name: params[:name], build_id: Jets.config.initial_id)
        @project.replace
      end
    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:project).permit(:name, :build_id)
    end
end
