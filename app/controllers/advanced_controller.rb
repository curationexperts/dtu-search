class AdvancedController < CatalogController

  def index
    if (params[:author] || params[:q] || params[:year] || params[:title])
      clauses =[] 
      clauses << params[:q] if params[:q].present?
      clauses << "author:(#{params[:author]})" if params[:author].present?
      clauses << "title:(#{params[:title]})" if params[:title].present?
      clauses << "year:(#{params[:year]})" if params[:year].present?
      redirect_to catalog_index_path(:q =>clauses.join(' '))
    end
  end


end
