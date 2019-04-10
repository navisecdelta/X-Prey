require 'date'

class XPrey
	def initialize(email_arr, company_name, breach_data="")
		@emails = email_arr.uniq
		@company_name = company_name

		@breach_data_indexed = {}

		if breach_data != ""
			records = breach_data.split("\n")

			records.each do |record|
				email = record.split(":")[0]

				if ! @emails.include?(email)
					@emails.push(email)
				end

				## Incase the password has a : in it :D
				if record.split(":").length > 2
					password = record.split(":")[1..-1].join(":")
				else
					password = record.split(":")[1]
				end

				if @breach_data_indexed.has_key?(email)
					@breach_data_indexed[email].push(password)
				else
					@breach_data_indexed[email] = [password]
				end
			end 
		end
	end

	def run()
		return generate_couples(@emails)
	end

	def generate_couples(emails)
		list = []
		passwords = generate_common_passes()

		emails.each do |email|
			if @breach_data_indexed.has_key? (email)
				breach_passwords = @breach_data_indexed[email]

				breach_passwords.each do |pass|
					list.push(email + ":" + pass)
				end
			end
			
			passwords.each do |pass|
				list.push(email + ":" + pass)
			end
		end

		return list
	end

	def generate_common_passes()
		passwords = []

		get_company_name_passwords(@company_name).each do |pass| 
			passwords.push(pass) 
		end

		generate_quarterly_passes.each do |pass|
			passwords.push(pass)
		end

		passwords.push("Pa$$w0rd!")

		return passwords
	end

	def get_company_name_passwords(company_name)
		passwords = []
		company_name.gsub!(" ", "")

		get_last_years.each do |year|
			passwords.push(company_name + year.to_s)
			passwords.push(company_name + year.to_s + "!")
		end

		return passwords
	end

	def generate_quarterly_passes()
		passwords = []
		quarterly_passes = get_valid_seasons_combos()
		
		quarterly_passes.each do |pass|
			passwords.push(pass)
			passwords.push(pass + "!")
		end
		return passwords
	end

	def get_valid_seasons_combos()
		years = get_last_years()
		seasons = get_last_seasons()

		valid_season_combos = []

		if Time.new.year < 60
			valid_season_combos.push(seasons[0].to_s.capitalize + years[0].to_s)
			valid_season_combos.push(seasons[0].to_s.capitalize + years[-1].to_s)
			valid_season_combos.push(seasons[1].to_s.capitalize + years[-1].to_s)
		else
			valid_season_combos.push(seasons[0].to_s.capitalize + years[-1].to_s)
			valid_season_combos.push(seasons[1].to_s.capitalize + years[-1].to_s)
		end

		return valid_season_combos
	end

	def get_last_seasons()
		if Date.today.yday().to_i < 60
			last_day = 1
		else
			last_day = Date.today.yday().to_i - 60
		end

		two_seasons = [
			season(last_day),
			season(Date.today.yday().to_i)
		]
	end

	def get_last_years()
		years = []
		current_year = Time.new.year

		years.push(current_year)

		if Date.today.yday().to_i < 60
			last_year = current_year - 1
			years.push(last_year)
		end

		years.reverse!

		return years
	end

    def season(year_day)
      # year_day = Date.today.yday().to_i
      year = Date.today.year.to_i
      is_leap_year = year % 4 == 0 && year % 100 != 0 || year % 400 == 0
      if is_leap_year and year_day > 60
        # if is leap year and date > 28 february 
        year_day = year_day - 1
      end

      if year_day >= 355 or year_day < 81
        result = :winter
      elsif year_day >= 81 and year_day < 173
        result = :spring
      elsif year_day >= 173 and year_day < 266
        result = :summer
      elsif year_day >= 266 and year_day < 355
       result = :autumn
      end

      return result
    end
end