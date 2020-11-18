module TinkoffInvestApi
  class TinkoffInvestApiError < StandardError

  end


  class RequestParamsError < TinkoffInvestApiError

  end

  class UnsupportableRequestMethod < TinkoffInvestApiError

  end
end
