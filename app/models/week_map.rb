class WeekMap < ActiveRecord::Base
  belongs_to :influencer

  attr_accessible :mon_0, :mon_1, :mon_2, :mon_3, :mon_4, :mon_5, :mon_6, :mon_7, :mon_8, :mon_9, :mon_10, :mon_11, :mon_12, :mon_13, :mon_14, :mon_15, :mon_16, :mon_17, :mon_18, :mon_19, :mon_20, :mon_21, :mon_22, :mon_23,
                  :tue_0, :tue_1, :tue_2, :tue_3, :tue_4, :tue_5, :tue_6, :tue_7, :tue_8, :tue_9, :tue_10, :tue_11, :tue_12, :tue_13, :tue_14, :tue_15, :tue_16, :tue_17, :tue_18, :tue_19, :tue_20, :tue_21, :tue_22, :tue_23,
                  :wed_0, :wed_1, :wed_2, :wed_3, :wed_4, :wed_5, :wed_6, :wed_7, :wed_8, :wed_9, :wed_10, :wed_11, :wed_12, :wed_13, :wed_14, :wed_15, :wed_16, :wed_17, :wed_18, :wed_19, :wed_20, :wed_21, :wed_22, :wed_23,
                  :thu_0, :thu_1, :thu_2, :thu_3, :thu_4, :thu_5, :thu_6, :thu_7, :thu_8, :thu_9, :thu_10, :thu_11, :thu_12, :thu_13, :thu_14, :thu_15, :thu_16, :thu_17, :thu_18, :thu_19, :thu_20, :thu_21, :thu_22, :thu_23,
                  :fri_0, :fri_1, :fri_2, :fri_3, :fri_4, :fri_5, :fri_6, :fri_7, :fri_8, :fri_9, :fri_10, :fri_11, :fri_12, :fri_13, :fri_14, :fri_15, :fri_16, :fri_17, :fri_18, :fri_19, :fri_20, :fri_21, :fri_22, :fri_23,
                  :sat_0, :sat_1, :sat_2, :sat_3, :sat_4, :sat_5, :sat_6, :sat_7, :sat_8, :sat_9, :sat_10, :sat_11, :sat_12, :sat_13, :sat_14, :sat_15, :sat_16, :sat_17, :sat_18, :sat_19, :sat_20, :sat_21, :sat_22, :sat_23,
                  :sun_0, :sun_1, :sun_2, :sun_3, :sun_4, :sun_5, :sun_6, :sun_7, :sun_8, :sun_9, :sun_10, :sun_11, :sun_12, :sun_13, :sun_14, :sun_15, :sun_16, :sun_17, :sun_18, :sun_19, :sun_20, :sun_21, :sun_22, :sun_23
end
