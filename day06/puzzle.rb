Race = Data.define(:time, :distance)

times, distances = File.readlines(ARGV[0], chomp: true)
                       .map { |arr| arr.split.map(&:to_i)[1..] }

races = []
times.each_with_index { |time, i| races << Race[time:, distance: distances[i]] }

def search_races(race:, compare_method:)
  (0..(race.time)).bsearch do |hold_time|
    distance = (hold_time * (race.time - hold_time))
    distance.public_send(compare_method, race.distance)
  end
end

def find_min_max(race)
  %i[> <=].map { |compare_method| search_races(race:, compare_method:) }
end

record_runs = races.each_with_object([]) do |race, records|
  start, finish = find_min_max(race)
  records << (finish - start) if start && finish
end

corrected_race = Race[time: times.join.to_i, distance: distances.join.to_i]
start, finish = find_min_max(corrected_race)

p record_runs.reduce(:*) # p1

p finish - start # p2
