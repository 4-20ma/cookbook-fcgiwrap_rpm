# encoding: utf-8

# returns true if platform family matches value (accepts :symbol or 'string')
# rubocop:disable CyclomaticComplexity
def platform?(value)
  platform = chef_run.node
  case value.to_s
  when 'debian' then platform[:platform_family] == 'debian'
  when 'rhel' then platform[:platform_family] == 'rhel'
  when 'rhel5' then platform[:platform_family] == 'rhel' &&
    platform[:platform_version].to_i == 5
  when 'rhel6' then platform[:platform_family] == 'rhel' &&
    platform[:platform_version].to_i == 6
  else false
  end # case
end # def
# rubocop:enable CyclomaticComplexity
