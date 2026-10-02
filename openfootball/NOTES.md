# Notes


``` ruby

recs = @leagues[key]
return nil if recs.nil?

recs.find { |rec| rec.cover?(season) }



        existing = @leagues[key] || []

        # exact duplicate row => ignore
        if existing.any? { |r| exact_duplicate?(r, rec) }
          next
        end

        # strict overlap check => no same-code overlap allowed
        if existing.any? { |r| overlaps?(r, rec) }
          conflict = existing.find { |r| overlaps?(r, rec) }
          raise ArgumentError,
            "overlapping league records for code #{raw_code.inspect}: " \
            "#{render_record(conflict)} overlaps with #{render_record(rec)}"
        end


def exact_duplicate?(a, b)
    a.basename == b.basename &&
      a.start_season == b.start_season &&
      a.end_season == b.end_season
  end

  def overlaps?(a, b)
    # open-ended ranges are treated as overlapping
    return true if a.start_season.nil? || a.end_season.nil? ||
                   b.start_season.nil? || b.end_season.nil?

    a.start_season <= b.end_season && b.start_season <= a.end_season
  end


```


```
tests for duplicates or overlap

# exact duplicate
# "at.1, 2018, 2020" repeated twice => ignored

# overlapping periods
# "at.1, 2018, 2020"
# "at.1, 2019, 2025" => raises ArgumentError

# historical split
# "at.1, 2018, 2020"
# "at.1, 2021, 2025" => allowed
```



alternate version:

``` ruby
module Fbup

class LeagueConfig

  Record = Struct.new(:basename, :start_season, :end_season, keyword_init: true) do
    def cover?(season)
      (start_season.nil? || start_season <= season) &&
        (end_season.nil? || end_season >= season)
    end
  end

  def self.find_by(code:, season:)
    builtin.find_by(code: code, season: season)
  end

  def self.builtin
    @leagues ||= begin
      leagues = new
      ['leagues'].each do |name|
        recs = read_csv("#{Openfootball.root}/config/#{name}.csv")
        leagues.add(recs)
      end
      leagues
    end
  end

  def self.norm(code)
    code.to_s.downcase.gsub(/[^\p{Ll}0-9]/, '')
  end

  def initialize
    @leagues = {}
  end

  def add(rows)
    rows.each do |row|
      basename = row['basename'].to_s.strip
      codes = row['code'].to_s.split(/[ ]*[|][ ]*/).map(&:strip).reject(&:empty?)
      next if codes.empty?

      start_season = row['start_season'].to_s.strip
      end_season   = row['end_season'].to_s.strip

      rec = Record.new(
        basename:      basename,
        start_season:  start_season.empty? ? nil : Season.parse(start_season),
        end_season:    end_season.empty?   ? nil : Season.parse(end_season)
      )

      codes.each do |raw_code|
        key = self.class.norm(raw_code)

        existing = @leagues[key] || []
        if existing.any? { |r| same_record?(r, rec) }
          next   # ignore exact duplicate row
        end

        if existing.any? { |r| overlapping?(r, rec) }
          raise ArgumentError,
            "overlapping league records for code #{raw_code.inspect}: " \
            "#{r_to_s(existing.first)} conflicts with #{record_to_s(rec)}"
        end

        @leagues[key] ||= []
        @leagues[key] << rec
      end
    end
  end

  def find_by(code:, season:)
    raise ArgumentError, "league code as string|symbol expected" unless code.is_a?(String) || code.is_a?(Symbol)

    season = Season.parse(season.to_s) unless season.is_a?(Season)
    key = self.class.norm(code)

    recs = @leagues[key]
    return nil if recs.nil?

    recs.find { |rec| rec.cover?(season) }
  end

  private

  def same_record?(a, b)
    a.basename == b.basename &&
      a.start_season == b.start_season &&
      a.end_season == b.end_season
  end

  def overlapping?(a, b)
    a_start = a.start_season
    a_end   = a.end_season
    b_start = b.start_season
    b_end   = b.end_season

    # Open-ended ranges count as overlapping
    return true if a_start.nil? || a_end.nil? || b_start.nil? || b_end.nil?

    a_start <= b_end && b_start <= a_end
  end

  def record_to_s(rec)
    "#{rec.basename} [#{rec.start_season || 'open'} .. #{rec.end_season || 'open'}]"
  end

  def r_to_s(rec)
    record_to_s(rec)
  end

end  # class LeagueConfig
end  # module Fbup
```




- add check for duplicate or overlapping records?

``` ruby
def add(rows)
  rows.each do |row|
    start_season = row['start_season'].to_s
    end_season   = row['end_season'].to_s

    rec = Record.new(
      basename:      row['basename'],
      start_season:  start_season.empty? ? nil : Season.parse(start_season),
      end_season:    end_season.empty? ? nil : Season.parse(end_season)
    )

    codes = row['code'].to_s.split(/[ ]*[|][ ]*/).map(&:strip).reject(&:empty?)
    next if codes.empty?

    codes.each do |raw_code|
      key = self.class.norm(raw_code)

      existing = @leagues[key] || []

      if existing.any? { |r| same_record?(r, rec) }
        next  # exact duplicate; ignore
      end

      if existing.any? { |r| overlapping?(r, rec) }
        raise ArgumentError,
          "overlapping league records for code #{raw_code.inspect}: " \
          "#{r.basename} #{r.start_season.inspect}-#{r.end_season.inspect} " \
          "vs #{rec.basename} #{rec.start_season.inspect}-#{rec.end_season.inspect}"
      end

      @leagues[key] ||= []
      @leagues[key] << rec
    end
  end
end

def same_record?(a, b)
  a.basename == b.basename &&
    a.start_season == b.start_season &&
    a.end_season == b.end_season
end

def overlapping?(a, b)
  a_start = a.start_season
  a_end   = a.end_season
  b_start = b.start_season
  b_end   = b.end_season

  # nil means open-ended / all-time
  a_start = a_start || b_start
  a_end   = a_end   || b_end

  # More robust: compare interval overlaps
  range_a = [a_start, a_end]
  range_b = [b_start, b_end]

  # if either side is open-ended, treat as "range intersects any"
  return true if a_start.nil? || b_start.nil? || a_end.nil? || b_end.nil?

  a_start <= b_end && b_start <= a_end
end
```