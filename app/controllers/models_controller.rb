class ModelsController < ApplicationController

  # iam_policy("s3")
  class_iam_policy(
    {
      action: ["s3:*"],
      effect: "Allow",
      resource: ["arn:aws:s3:::ngs-erdd-models","arn:aws:s3:::ngs-erdd-models/*"]
    }
  )
  before_action :get_models, only: [:list,:form]
  layout false

  # GET /models/list
  def list
    defaults = {}
    @models.each do |model, versions|
      defaults[model] = versions.max
    end
    return_data             = {}
    return_data['defaults'] = defaults
    return_data['models']   = @models
    return_data['stage']    = params[:stage]
    return_data['type']     = params[:type]
    render json: return_data.to_json
  end

  def form
    form_template_file           = File.read(File.join(Jets.root.to_s, "app", "views","models","modelsForm.json"))
    client_models_template_file  = File.read(File.join(Jets.root.to_s, "app", "views","models","clientModels.json"))
    model_template_file          = File.read(File.join(Jets.root.to_s, "app", "views","models","model_template.json"))

    allClientModels = {}

    @models.each do |model, versions|
      client = model.split('-')[0]
      allClientModels[client] = [] unless allClientModels[client]
      allClientModels[client].push({"name" => model, "versions" => versions})
    end

    index = 1
    models_form = JSON.parse(form_template_file)

    allClientModels.each do |client,clientModels|
      models_form["schema"]["required"].push "#{client}_models"
      models_form["startval"]["#{client}_models"] = [] unless models_form["startval"]["#{client}_models"]
      client_models_template = JSON.parse(client_models_template_file)
      client_models_template["title"] = "#{client} models"
      client_models_template["propertyOrder"] = index
      index += 1

      clientModels.each do |model|
        models_form["startval"]["#{client}_models"].push({ "name" => model["name"], "version" => model['versions'].max.to_s })
        # clients_model_template
        model_template = JSON.parse(model_template_file)
        model_template["title"] = model["name"]
        model_template["properties"]["name"]["enum"] = [model["name"]]
        model_template["properties"]["version"]["enum"] = model['versions'].map { |v| v.to_s  }
        model_template["properties"]["version"]["default"] = model['versions'].max.to_s
        # model_template["title"] = model["name"]
        # TODO: feel model's template
        client_models_template["items"]["oneOf"].push model_template
      end
      models_form["schema"]["properties"]["#{client}_models"] = client_models_template
    end

    render json: models_form.to_json
  end

  private

    def get_models
      @s3_client = Aws::S3::Client.new
      prefix = "models/#{params[:type]}/#{params[:stage]}"
      resp = @s3_client.list_objects_v2({bucket: Jets.config.s3_bucket, prefix: "#{prefix}/"})
      @models = {}
      resp[:contents].each do |obj|
        if obj.key.ends_with? ".war"
          model_path_parts = obj.key.split /\/|\./
          client   = model_path_parts[3]
          facility = model_path_parts[4]
          version  = model_path_parts[5]
          model_name = "#{client}-#{facility}"
          @models[model_name] = [] unless  @models[model_name]
          @models[model_name].push(version.to_i)
        end
     end

    end

    # Only allow a trusted parameter "white list" through.
    def project_params
      params.require(:model).permit(:type,:stage)
    end
end
