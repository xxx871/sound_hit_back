# app/services/update_user_service.rb
class UpdateUserService
  def initialize(user, params)
    @user = user
    @params = params
  end

  def call
    update_user_attributes
    find_high_and_low_notes
    validate_notes
    update_gender
    save_notes
    save_user
  end

  private

  def update_user_attributes
    @user.assign_attributes(@params.except(:high_note, :low_note, :gender))
  end

  def find_high_and_low_notes
    if @params[:high_note].present?
      @high_note = Note.find_by(id: @params[:high_note][:id])
      raise "指定された音域高が見つかりません" unless @high_note
    end

    if @params[:low_note].present?
      @low_note = Note.find_by(id: @params[:low_note][:id])
      raise "指定された音域低が見つかりません" unless @low_note
    end
  end

  def validate_notes
    if @high_note && @low_note && @high_note.frequency < @low_note.frequency
      raise "音域高は音域低より低くすることはできません"
    end
  end

  def update_gender
    if @params[:gender].present?
      gender = Gender.find_by(name: @params[:gender])
      @user.gender = gender if gender
    end
  end

  def save_notes
    if @high_note
      user_high_note = UserHighNote.find_or_initialize_by(user: @user)
      user_high_note.note = @high_note
      user_high_note.save!
    end

    if @low_note
      user_low_note = UserLowNote.find_or_initialize_by(user: @user)
      user_low_note.note = @low_note
      user_low_note.save!
    end
  end

  def save_user
    @user.save!
  rescue ActiveRecord::RecordInvalid => e
    raise e.record.errors.full_messages.join(", ")
  end
end
