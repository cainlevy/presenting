ActionView::Base.class_eval { include Presenting::Helpers }
ActionController::Base.const_set(:SearchConditions, Presenting::SearchConditions)

