use_debug false
use_bpm 130

#MIXER
master = 1.0

synth1_amp = 1
synth2_amp = 0.3

base_amp = 1.0
kick_amp = 1
snare_amp = 0.125
wdrop_amp = 0.05
hihat_amp = 0.005

atmo_amp = 0.5

#SAMPS
s = "/Users/rober/OneDrive/Desktop/_projects/tribeholz/sound/Tracks/kalimba_jam/samples"
snare = "/Users/rober/Documents/samples/Ghosthack - Drum Hero 3/One-Shots/Snares/Hybrid Snares/Hybrid Snare (9).wav"
atmo = "/Users/rober/Documents/samples/Ghosthack - Deep Dark Techno/DDT_One Shots_GH/DDT_Atmosphere_GH/DDT_Atmoshpere_Fiuk_GH.wav"

#RHYTMS
kick_rhythm = (ring 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
               1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
               1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
               1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1)

#METRO
live_loop :metro do
  sleep 1
end

#DRUM PART
live_loop :kick do
  with_fx :eq, low_shelf: -0.25,  low: -0.25 do
    sample s, 0, amp: kick_amp * master * kick_rhythm.tick, beat_stretch: 1.05, cutoff: 70, release: 0.015# * kick_rhythm.tick
    sleep 0.5
  end
end

with_fx :reverb, mix: 0.5 do
  live_loop :snare do
    sleep 2
    sample snare,
      amp: snare_amp * master * base_amp,
      beat_stretch: 0.75,
      cutoff: 90
  end
end

with_fx :ping_pong, feedback: 0.5 do
  live_loop :drop do
    sleep 4
    sample  s, 1,
      amp: wdrop_amp * master * base_amp,
      beat_stretch: 2,
      cutoff: 90
  end
end


live_loop :hihat do
  sync :kick
  sample s,2, amp: hihat_amp * master * base_amp, rate: 1.5
  sleep 0.5
  sample s,2, amp: hihat_amp * master * base_amp, rate: 1.25
  sleep 0.5
  sample s,2, amp: hihat_amp * master * base_amp, rate: 1.0
  sleep 0.5
  sample :drum_cymbal_closed, amp: hihat_amp * master * base_amp, rate: 1.25
end


#SYNTH PART
live_loop :synth1 do
  sync :metro
  #stop
  with_fx :reverb, room: 0.75, mix: 0.5 do
    with_fx :lpf, cutoff: 90 do
      use_random_seed 29
      32.times do
        with_synth :kalimba do
          synth_co = range(65, 72, 0.5).mirror
          n = (ring :f3, :g1, :e2, :d2).choose
          play scale(n, :bartok).choose,
            release: (ring 0.15, 0.15, 0.18, 0.18).tick,
            cutoff: synth_co.look,
            res: 0.8,
            wave: 0,
            amp: synth1_amp  * master,
            pitch: 12
          sleep 0.5
        end
      end
    end
  end
end


live_loop :synth2 do
  sync :metro
  stop
  with_fx :reverb, mix: 0.5, room: 0.75 do
    use_random_seed 3 #(3,16,12)
    2.times do
      with_synth :organ_tonewheel do
        synth_co = range(80, 90, 0.5).mirror
        n = (ring :d3, :f2, chord(:G, :major7), :a3).choose
        play scale(n, :bartok).choose,
          release: (ring 0.15, 0.1, 0.15,  0.1).tick,
          cutoff: synth_co.look,
          res: 0.8,
          amp: synth2_amp * master,
          pitch: -2
        sleep 0.5
      end
    end
  end
end

live_loop :lead do
  sync :metro
  stop
  with_fx :slicer, phase: 0.5 do
    with_fx :hpf, cutoff: 70 do
      synth_co = range(70, 75, 2.5).mirror
      sample atmo,
        amp: atmo_amp * master,
        rate: 1,
        beat_stretch: 4,
        release: 0.5,
        cutoff: synth_co.look,
        pitch: 20,
        pan:  (ring 1, -1, 1, -1).tick
      sleep 4
    end
  end
end


