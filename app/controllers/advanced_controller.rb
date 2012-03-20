class AdvancedController < CatalogController

  def index
    types = [:author, :title, :identifier, :keywords, :journal]
    if ([:q, :range, :f] + types).any?{|t| params[t].present?} 
      filtered_params = params.dup
      filtered_params.delete(:controller)
      text = filtered_params.delete(:q)
      clauses =[] 
      clauses << text if text.present?
      types.each do |type|
        filtered_params.delete(type)
        clauses << "#{type}:(#{params[type]})" if params[type].present?
      end
      filtered_params[:q] = clauses.join(' ')
      redirect_to catalog_index_path(filtered_params)
    end
  end


end
