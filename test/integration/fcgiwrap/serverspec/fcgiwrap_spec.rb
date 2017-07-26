# encoding: utf-8
require 'spec_helper'

describe 'fcgiwrap_rpm::default' do
  #---------------------------------------------------------------- locals
  home = Pathname.new('/') + 'home' + 'vagrant'
  products = home + 'products'
  rpmbuild = home + 'rpmbuild'
  rpms = rpmbuild + 'RPMS'
  sources = rpmbuild + 'SOURCES'
  output = 'fcgiwrap-1.1.0'
  release = '1'
  src_filepath = sources + 'fcgiwrap'
  rpm_filepath = rpms + 'x86_64' + "#{output}-#{release}.el6.x86_64.rpm"

  #----------------------------------------------------------------- package[]
  # packages required to build all rpms
  describe package('automake') do
    it 'installs described package' do
      expect(subject).to be_installed
    end # it
  end # describe

  describe package('git') do
    it 'installs described package' do
      expect(subject).to be_installed
    end # it
  end # describe

  describe package('pkgconfig') do
    it 'installs described package' do
      expect(subject).to be_installed
    end # it
  end # describe

  describe package('rpm-build') do
    it 'installs described package' do
      expect(subject).to be_installed
    end # it
  end # describe

  # development packages required specifically for fcgiwrap
  describe package('fcgi-devel') do
    it 'installs described package' do
      expect(subject).to be_installed
    end # it
  end # describe

  #--------------------------------------------------------------- directory[]
  describe file(rpmbuild) do
    it 'is a directory' do
      expect(subject).to be_directory
    end # it

    it 'is owned by vagrant' do
      expect(subject).to be_owned_by('vagrant')
    end # it

    it 'is in group vagrant' do
      expect(subject).to be_grouped_into('vagrant')
    end # it

    it 'is mode 755' do
      expect(subject).to be_mode(755)
    end # it
  end # describe

  describe file(sources) do
    it 'is a directory' do
      expect(subject).to be_directory
    end # it

    it 'is owned by vagrant' do
      expect(subject).to be_owned_by('vagrant')
    end # it

    it 'is in group vagrant' do
      expect(subject).to be_grouped_into('vagrant')
    end # it

    it 'is mode 755' do
      expect(subject).to be_mode(755)
    end # it
  end # describe

  #----------------- bash[git_clone https://github.com/schnell18/fcgiwrap.git]
  describe file(src_filepath) do
    it 'is a directory' do
      expect(subject).to be_directory
    end # it

    it 'is owned by vagrant' do
      expect(subject).to be_owned_by('vagrant')
    end # it

    it 'is in group vagrant' do
      expect(subject).to be_grouped_into('vagrant')
    end # it

    it 'is mode 755' do
      expect(subject).to be_mode(755)
    end # it
  end # describe

  #--------------------------------------------------------- bash[git_archive]
  describe file(src_filepath + "#{output}.tgz") do
    it 'is a file' do
      expect(subject).to be_file
    end # it

    it 'is owned by vagrant' do
      expect(subject).to be_owned_by('vagrant')
    end # it

    it 'is in group vagrant' do
      expect(subject).to be_grouped_into('vagrant')
    end # it

    it 'is mode 644' do
      expect(subject).to be_mode(644)
    end # it
  end # describe

  #------------------------------------------------------------ bash[rpmbuild]
  describe file(rpm_filepath) do
    it 'is a file' do
      expect(subject).to be_file
    end # it

    it 'is owned by vagrant' do
      expect(subject).to be_owned_by('vagrant')
    end # it

    it 'is in group vagrant' do
      expect(subject).to be_grouped_into('vagrant')
    end # it

    it 'is mode 644' do
      expect(subject).to be_mode(644)
    end # it
  end # describe

  #------------------------------------------------- bash[copy_final_products]
  describe file("#{products}/fcgiwrap-1.1.0-1.el6.x86_64.rpm") do
    it 'is a file' do
      expect(subject).to be_file
    end # it

    # it 'is owned by vagrant' do
    #   expect(subject).to be_owned_by('vagrant')
    # end # it
    #
    # it 'is in group vagrant' do
    #   expect(subject).to be_grouped_into('vagrant')
    # end # it

    it 'is mode 644' do
      expect(subject).to be_mode(644)
    end # it
  end # describe
end # describe
