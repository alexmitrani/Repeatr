# Choice modelling --------------------------------

# The basic model.

ml.Repeatr31 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                       + yearsold_6 + yearsold_7 + yearsold_8 , data = Repeatr3)

summary.ml.Repeatr31 <- summary(ml.Repeatr31)

summary.ml.Repeatr31

# A more detailed model that includes first song instrumental effect and potential differences between the preferences of Ian MacKaye and Guy Picciotto regarding the age of their songs.

ml.Repeatr32 <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                       + yearsold_6 + yearsold_7 + yearsold_8 + yearsold_1_vp + yearsold_2_vp + yearsold_3_vp + yearsold_4_vp + yearsold_5_vp + yearsold_6_vp + yearsold_7_vp + yearsold_8_vp + first_song_instrumental, data = Repeatr3)

summary.ml.Repeatr32 <- summary(ml.Repeatr32)

summary.ml.Repeatr32

# First song model ---------------------------------------------------

Repeatr3_fs <- Repeatr3 %>%
  filter(first_song==1)

Repeatr3_fs_counts <- Repeatr3_fs %>%
  filter(choice==TRUE) %>%
  group_by(alt) %>%
  summarise(chosen=n()) %>%
  mutate(songid=as.integer(alt)) %>%
  ungroup()

Repeatr3_fs_counts <- Repeatr3_fs_counts %>%
  left_join(mysongidlookup) %>%
  select(alt, song, chosen)

Repeatr3_fs <- Repeatr3_fs %>%
  left_join(Repeatr3_sno_counts)

Repeatr3_fs <- Repeatr3_fs %>%
  mutate(yearsold_3 = yearsold_3 + yearsold_4 + yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8)

# It is necessary to remove the alternatives that were never chosen as the first song

Repeatr3_fs <- Repeatr3_fs %>%
  filter(is.na(chosen)==FALSE)

ml.Repeatr3_fs <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3, data = Repeatr3_fs)

summary.ml.Repeatr3_fs <- summary(ml.Repeatr3_fs)

summary.ml.Repeatr3_fs

# Last song model ---------------------------------------------------

Repeatr3_ls <- Repeatr3 %>%
  filter(last_song==1)

Repeatr3_ls_counts <- Repeatr3_ls %>%
  filter(choice==TRUE) %>%
  group_by(alt) %>%
  summarise(chosen=n()) %>%
  mutate(songid=as.integer(alt)) %>%
  ungroup()

Repeatr3_ls_counts <- Repeatr3_ls_counts %>%
  left_join(mysongidlookup) %>%
  select(alt, song, chosen)

Repeatr3_ls <- Repeatr3_ls %>%
  left_join(Repeatr3_ls_counts)

# It is necessary to remove the alternatives that were never chosen as the last song

Repeatr3_ls <- Repeatr3_ls %>%
  filter(is.na(chosen)==FALSE)

ml.Repeatr3_ls <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5 + yearsold_6 + yearsold_7 + yearsold_8, data = Repeatr3_ls)

summary.ml.Repeatr3_ls <- summary(ml.Repeatr3_ls)

summary.ml.Repeatr3_ls

# intermediate song model, the idea being to model the two main vocalists taking turns to sing

Repeatr3_is <- Repeatr3 %>%
  filter(first_song==0 & last_song==0)

ml.Repeatr3_is <- mlogit(choice ~ yearsold_1 + yearsold_2 + yearsold_3 + yearsold_4 + yearsold_5
                         + yearsold_6 + yearsold_7 + yearsold_8 + vp_lag_vocals_mackaye + vm_lag_vocals_picciotto, data = Repeatr3_is)

summary.ml.Repeatr3_is <- summary(ml.Repeatr3_is)

summary.ml.Repeatr3_is
