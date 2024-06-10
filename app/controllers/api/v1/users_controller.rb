module Api
  module V1
    class UsersController < ApplicationController
      before_action :authenticate_api_v1_user!

      def show
        user = current_api_v1_user
        render json: {
          id: user.id,
          name: user.name,
          gender: user.gender&.name,
          user_high_note: note_to_json(user.high_note),
          user_low_note: note_to_json(user.low_note),
          scores: user.scores.map { |score| { mode: score.mode.name, difficulty: score.difficulty.name, score: score.score } }
        }
      end

      private

      def note_to_json(note)
        return nil unless note
        {
          id: note.id,
          frequency: note.frequency,
          ja_note_name: note.ja_note_name,
          en_note_name: note.en_note_name
        }
      end
    end
  end
end
