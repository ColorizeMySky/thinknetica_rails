class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @attachment = ActiveStorage::Attachment.find(params[:id])

    if current_user.owner_of?(@attachment.record)
      @attachment.purge
      redirect_to request.referer || root_path, notice: 'Файл успешно удален'
    else
      redirect_to request.referer || root_path, alert: 'У вас нет прав для удаления этого файла'
    end
  end
end
