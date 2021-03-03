# frozen_string_literal: true

module SolidusYotpo
  module BaseHelper
    def stars(score, editable: false)
      fragment_name = 'review[score]'

      case score
      when SolidusYotpo::Review
        review = score
        score = review.score
        # TODO: Handle input name/id generation appropriately in both
        # form and multiple instances (review listing)
      end

      (1..SolidusYotpo.config.max_score).reverse_each.map do |n|
        fragment_id = "#{fragment_name.tr('][', '_')}_#{n}".squeeze('_')

        radio_button_tag(fragment_name, n, score.to_i == n, id: fragment_id, disabled: !editable) +
        label_tag(fragment_id, t("score_#{n}", scope: 'solidus_yotpo.scores'))
      end.join
    end

    def score_text(score)
      score = score.try(:score) || score
      "#{t('solidus_yotpo.stars', count: score)} #{t('solidus_yotpo.out_of', total: SolidusYotpo.config.max_score)}"
    end
  end
end
