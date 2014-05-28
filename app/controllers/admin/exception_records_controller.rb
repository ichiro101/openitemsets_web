class Admin::ExceptionRecordsController < Admin::AdminController

  def index
    @exception_records = ExceptionRecord.page(params[:page])
    @exception_records = @exception_records.order(:updated_at => :desc)

    @page_title = "Listing of Error Records"
  end

end
