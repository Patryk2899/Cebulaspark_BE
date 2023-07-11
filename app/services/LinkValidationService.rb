# frozen_string_literal_true

require 'uri'
require 'httpx'

class LinkValidationService
  def initialize(url)
    @url = url
  end

  def valid?
    valid_url? && safe?
  end

  private

  def valid_url?
    url = URI.parse(@url)
    (url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)) && url.host.present?
  rescue StandardError
    false
  end

  def safe?
    uri = ENV['SAFE_BROWSING_URL'] + ENV['GOOGLE_KEY']
    res = HTTPX.post(uri, json: body_template)

    return res.headers['content-length'] == '3' && res.status == 200 if res

    false
  end

  def body_template
    {
      threatInfo: {
        threatTypes: %w[UNWANTED_SOFTWARE MALWARE],
        platformTypes: ['ANY_PLATFORM'],
        threatEntryTypes: ['URL'],
        threatEntries: [{ url: @url.to_s }]
      }
    }
  end
end
