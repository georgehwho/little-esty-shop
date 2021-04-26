class HolidayService
  def conn
    Faraday.new(
      url: "https://date.nager.at"
    )
  end

  def next_us_holidays
    resp = conn.get("Api/v2/NextPublicHolidays/US")
    json = JSON.parse(resp.body, symbolize_names: true)
    json[0..2]
  end
end