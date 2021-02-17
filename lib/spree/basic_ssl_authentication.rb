module Spree

  module BasicSslAuthentication

    extend ActiveSupport::Concern

    included do
      if !(Rails.version[/(^\d\.\d)/].to_f > 6)
        force_ssl if: :ssl_configured?
      else
        ActiveSupport::Deprecation.warn(<<-MESSAGE.squish)
          Controller-level `force_ssl` has been deprecated and removed from Rails 6.1. 
          Please enable `config.force_ssl` in your environment configuration to enable 
          the ActionDispatch::SSL middleware to more fully enforce that your application 
          communicate over HTTPS. If needed, you can use `config.ssl_options` to exempt 
          matching endpoints from being redirected to HTTPS.
          MESSAGE
      end
      before_action :authenticate
    end

    protected

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == Spree::Config.shipstation_username && password == Spree::Config.shipstation_password
      end
    end

    private

    def ssl_configured?
      Spree::Config.shipstation_ssl_encrypted
    end

  end

end
