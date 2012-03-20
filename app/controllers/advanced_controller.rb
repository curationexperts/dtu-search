class AdvancedController < CatalogController

  def index
    types = [:author, :title, :identifier, :keywords, :journal]
    if ([:q, :year, :f] + types).any?{|t| params[t].present?} 
      clauses =[] 
      clauses << params[:q] if params[:q].present?
      types.each do |type|
        clauses << "#{type}:(#{params[type]})" if params[type].present?
      end
      clauses << "year:(#{params[:year]})" if params[:year].present?
      redirect_to catalog_index_path(:q =>clauses.join(' '), :f=>params[:f])
    end
  end


end
