module Api
  module V1
    class ScoresController < ApplicationController
      before_action :authenticate_api_v1_user!, except: [:ranking]
      before_action :set_mode_difficulty, only: [:update, :ranking]

      def update
        new_score = params[:score].to_i
        current_score = current_api_v1_user.scores.find_by(mode_id: @mode_id, difficulty_id: @difficulty_id)

        unless current_score
          new_score_record = current_api_v1_user.scores.create(mode_id: @mode_id, difficulty_id: @difficulty_id, score: new_score)
          return render json: { status: 'created', score: new_score_record }, status: :created
        end

        return render json: { status: 'not_updated', score: current_score }, status: :ok if new_score <= current_score.score

        current_score.update(score: new_score)
        render json: { status: 'updated', score: current_score }, status: :ok
      end

      def ranking
        scores = Score.where(mode_id: @mode_id, difficulty_id: @difficulty_id).order(score: :desc).limit(10)
        render json: scores.as_json(include: { user: { only: [:name] } })
      end

      private

      def set_mode_difficulty
        @mode_id = params[:mode_id]
        @difficulty_id = params[:difficulty_id]
      end
    end
  end
end
