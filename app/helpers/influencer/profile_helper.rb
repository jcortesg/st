module Influencer::ProfileHelper
  # Gets the influencer sex for presentation
  def influencer_sex(sex)
    case sex
      when 'M'
        'Hombre'
      when 'F'
        'Mujer'
      else
        '-'
    end
  end

  # Gets the influencer age for presentation
  def influencer_age(birthday)
    if birthday.blank?
      '-'
    else
      now = Time.now.utc.to_date
      now.year - birthday.year - (birthday.to_date.change(:year => now.year) > now ? 1 : 0)
    end
  end
end
