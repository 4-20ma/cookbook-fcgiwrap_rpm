# encoding: utf-8

# returns true if platform family matches value (accepts :symbol or 'string')
# rubocop:disable CyclomaticComplexity
def platform?(value)
  platform = backend.check_os
  case value.to_s
  when 'debian' then platform[:family] == 'Debian'
  when 'rhel' then platform[:family] == 'RedHat'
  when 'rhel5' then platform[:family] == 'RedHat' &&
    platform[:release].to_i == 5
  when 'rhel6' then platform[:family] == 'RedHat' &&
    platform[:release].to_i == 6
  else false
  end # case
end # def
# rubocop:enable CyclomaticComplexity
