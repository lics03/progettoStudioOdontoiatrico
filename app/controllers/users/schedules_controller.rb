# class SchedulesController < ApplicationController
#     def make_google_calendar_reservations
#       @schedule = @cohort.schedules.find_by(slug:  
#         params[:slug])
#       @calendar = GoogleCalendarWrapper.new(current_user)
#       @calendar.book_rooms(@schedule)
#     end
# end


# # class GoogleCalendarWrapper
        
# #     def initialize(current_user)
# #         configure_client(current_user)
# #     end

# #     def configure_client(current_user)
# #         @client = Google::APIClient.new
# #         @client.authorization.access_token = current_user.token
# #         @client.authorization.refresh_token = current_user.refresh_token
# #         @client.authorization.client_id = Rails.application.secrets.google_client_id
# #         @client.authorization.client_secret = Rails.application.secrets.google_client_secret
# #         @client.authorization.refresh!
# #         @service = @client.discovered_api('calendar', 'v3')
# #     end

# #     def calendar_id(schedule)
# #       response = @client.execute(api_method: @service.calendar_list.list)
# #       calendars = JSON.parse(response.body)
# #       calendar = calendars["items"].select {|cal| 
# #         cal["id"].downcase == schedule.calendar_id} calendar["id"]
# #     end

# #     def new_event(summary, start_time, end_time, description)
# #         event = {
# #           summary: summary,
# #           start: {dateTime: start_time},  
# #           end: {dateTime: end_time},#2016-03-20T12:04:00+0000},  
# #           description: description,  
# #         }

# #         @client.execute(:api_method => @service.events.insert,
# #           :parameters => {'calendarId' => calendar_id,
# #             'sendNotifications' => true},
# #           :body => JSON.dump(event),
# #           :headers => {'Content-Type' => 'application/json'})
# #     end

# #     def get_events(start_time, end_time)
# #         response = @client.execute(api_method: @service.freebusy.query, 
# #           body: JSON.dump({timeMin: start_time,
# #           timeMax: end_time,
# #           items: [calendar_id]}),
# #           headers: {'Content-Type' => 'application/json'})
# #         return response
# #     end
# end