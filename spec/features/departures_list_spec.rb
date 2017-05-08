require "rails_helper"

feature "List of Departures", type: :feature do
  before { Timecop.freeze DateTime.parse("12/12/2017 12:43 CDT") }
  after { Timecop.return }

  let!(:shaw) { create(:stop, stop_name: 'Shaw') }
  3.times do |i|
    let!("trip#{i}".to_sym) { create(:trip, :with_route, :with_available_calendar) }
  end

  let!(:stop_time0) { create(:stop_time, stop: shaw, departure_hour: 12, departure_minute: 44, trip: trip0)}
  let!(:stop_time1) { create(:stop_time, stop: shaw, departure_hour: 26, departure_minute: 25, trip: trip1)}
  let!(:stop_time2) { create(:stop_time, stop: shaw, departure_hour: 7, departure_minute: 12, trip: trip2)}

  scenario "stop page lists departures" do
    visit "/stops/#{shaw.id}"

    expect(page).to have_text "#{trip0.route.route_short_name} 12:44 PM"
    expect(page).to have_text "#{trip1.route.route_short_name} 2:25 AM"
    expect(page).not_to have_text "#{trip2.route.route_short_name} 7:12 AM"
  end
end
