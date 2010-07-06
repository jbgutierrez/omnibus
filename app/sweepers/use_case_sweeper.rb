class UseCaseSweeper < ActionController::Caching::Sweeper
  observe UseCase

  def after_save(use_case)
    clear_use_cases_cache(use_case)
  end

  def after_destroy(use_case)
    clear_use_cases_cache(use_case)
  end

  private

  def clear_use_cases_cache(use_case)
    expire_fragment "#{use_case.id}-testrunner"
    expire_fragment "#{use_case.id}-ppee_test"
  end
  
end
