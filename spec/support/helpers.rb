# frozen_string_literal: true

module Helpers
  def subject_json(subject)
    JSON.parse(subject.to_json)
  end
end
