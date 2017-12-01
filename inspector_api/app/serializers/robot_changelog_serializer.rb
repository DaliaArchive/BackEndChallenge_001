class RobotChangelogSerializer < ActiveModel::Serializer
  attributes :type, :changes

  def type
    object.type_str
  end

  def changes
    json_hash = {}
    json_hash[object.updated_at.strftime("%Y-%m-%d %H:%M:%S")] = if (object.changeset || {}).size > 0
      get_diff(*object.changeset)
    else
      {}
    end
    json_hash
  end

  private
    def get_diff(hash1, hash2)
      hash1 ||= {}
      hash2 ||= {}
      (hash1.keys | hash2.keys).inject({}) do |diff, k|
        if hash1[k] != hash2[k]
          diff[k] = [hash1[k], hash2[k]]
        end
        diff
      end
    end
end