class Feature < ActiveRecord::Base
  NIL_FEATURE = new(value: nil)

  belongs_to :maintenance_record

  def self.diffs(features_a, features_b)
    features_b.each_with_object({}.with_indifferent_access) { |feature_b, differences|
      if features_a.present?
        feature_a = features_a.detect {|feature| feature.key == feature_b.key }

        if feature_a.present?
          if feature_a.value != feature_b.value
            differences[feature_b.key] = [feature_a, feature_b]
          end
        else
          differences[feature_b.key] = [NIL_FEATURE, feature_b]
        end
      else
        differences[feature_b.key] = [NIL_FEATURE, feature_b]
      end
    }.compact
  end
end
