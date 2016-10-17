#:  * `formula-versions` `--bottle-version-map` <formula>:
#:    Display the bottle version map for a formula.
#:
#:  * `formula-versions` `--rev-list` <formula>:
#:    List revisions for a formula, along with corresponding versions for valid 
#:    formulae in those revisions.

require "formula_versions"

module Homebrew
  module_function
  
  def formula_versions
    if ARGV.include? "--bottle-version-map"
      display_bottle_version_map
    elsif ARGV.include? "--rev-list"
      display_rev_list
    else
      raise "Must supply one of --bottle-version-map or --rev-list"
    end
  end

  def display_bottle_version_map
  	raise "Must specify exactly one formula" if ARGV.formulae.length != 1
    f = ARGV.formulae.first

    bottle_map = FormulaVersions.new(f).bottle_version_map("origin/master")
    bottle_map.each do |pkg_ver, rebuilds|
      puts "#{pkg_ver}: #{rebuilds}"
    end
  end

  def display_rev_list
    raise "Must specify exactly one formula" if ARGV.formulae.length != 1
    f = ARGV.formulae.first
    
    fv = FormulaVersions.new(f);
    fv.rev_list("origin/master") do |rev|
      f_rev = nil
      fv.formula_at_revision(rev) do |f_rev0|
        f_rev = f_rev0
      end
      if f_rev.nil?
        puts "#{rev}"
      else
        puts "#{rev}: #{f_rev.pkg_version}"
      end
    end
  end

end


# Adapter for using as an external command

Homebrew.formula_versions