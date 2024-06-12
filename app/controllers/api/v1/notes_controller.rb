module Api
  module V1
    class NotesController < ApplicationController

      def index
        notes = Note.all
        render json: notes
      end

      def range
        low_note = Note.find_by(en_note_name: params[:low])
        high_note = Note.find_by(en_note_name: params[:high])

        if low_note.nil? || high_note.nil?
          render json: { error: 'One or both notes not found' }, status: :unprocessable_entity
          return
        end

        low_frequency = [low_note.frequency, high_note.frequency].min
        high_frequency = [low_note.frequency, high_note.frequency].max
      
        notes = Note.where("frequency >= ? AND frequency <= ?", low_frequency, high_frequency)
        render json: notes
      end
    end
  end
end
