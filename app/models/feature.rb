class Feature < ActiveRecord::Base
  NIL_FEATURE = new(value: nil)

  belongs_to :maintenance_record

  # Finds differences between two groups of features
  #
  # == Parameters:
  # features_a::
  #   [Feature.new(key: 'foo', value: 'bar')]
  #
  # freatures_b::
  #   same as features_a
  #
  # == Returns:
  #   Array of differences.
  #
  #   If key matched but values are different:
  #     returns [matched_previous_feature, matched_new_feature]
  #   If no matched key found::
  #     returns [NIL_FEATURE, feature_b]
  #     * NIL_FEATURE is a Feature with no key and value
  #   If features_a not given
  #     returns [NIL_FEATURE, feature_b]
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
