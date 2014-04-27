# encoding: utf-8
require 'spec_helper'

describe 'fcgiwrap.rpm::default' do
  [
    { :platform => 'centos', :version => '6.5' }
  ].each do |i|
    context "#{i[:platform]}/#{i[:version]}" do
      # need to use let instead of cached so mocks will work properly (slower)
      let(:chef_run) do
        ChefSpec::Runner.new(i) do |node|
          # set cookbook attributes
          node.set['fcgiwrap']['devel_packages'] = %w(fcgi package2)
        end.converge(described_recipe)
      end # let

      #------------------------------------------------------ include_recipe[]
      describe 'build-essential' do
        it 'includes described recipe' do
          expect(chef_run).to include_recipe(subject)
        end # it
      end # describe

      describe 'yum-epel' do
        it 'includes described recipe' do
          expect(chef_run).to include_recipe(subject)
        end # it
      end # describe

      #------------------------------------------------------------- package[]
      describe 'automake' do
        it 'installs described package' do
          expect(chef_run).to install_package(subject)
        end # it
      end # describe

      describe 'git' do
        it 'installs described package' do
          expect(chef_run).to install_package(subject)
        end # it
      end # describe

      describe 'pkgconfig' do
        it 'installs described package' do
          expect(chef_run).to install_package(subject)
        end # it
      end # describe

      describe 'rpm-build' do
        it 'installs described package' do
          expect(chef_run).to install_package(subject)
        end # it
      end # describe

      describe 'fcgi-devel' do
        it 'installs described package' do
          expect(chef_run).to install_package(subject)
        end # it
      end # describe

      describe 'package2-devel' do
        it 'installs described package' do
          expect(chef_run).to install_package(subject)
        end # it
      end # describe

      #-------------------------------------------------------- bash[git_pull]
      describe 'git_pull' do
        it 'runs described bash script' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(true)
          expect(chef_run).to run_bash(subject).with_user('vagrant')
            .with_group('vagrant')
        end # it

        it 'does not run described bash script' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(false)
          expect(chef_run).to_not run_bash(subject)
        end # it
      end # describe

      #------------- bash[git_clone https://github.com/schnell18/fcgiwrap.git]
      describe 'git_clone https://github.com/schnell18/fcgiwrap.git' do
        it 'runs described bash script' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(false)
          expect(chef_run).to run_bash(subject).with_user('vagrant')
            .with_group('vagrant')
        end # it

        it 'does not run described bash script' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(true)
          expect(chef_run).to_not run_bash(subject)
        end # it
      end # describe

      #----------------------------------------------------- bash[git_archive]
      describe 'git_archive' do
        it 'runs described bash script' do
          expect(chef_run).to run_bash(subject).with_user('vagrant')
            .with_group('vagrant')
        end # it
      end # describe

      #------------------------------------ bash[chown /home/vagrant/rpmbuild]
      describe 'chown /home/vagrant/rpmbuild' do
        it 'runs described bash script' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(true)
          expect(chef_run).to run_bash(subject).with_user(nil)
            .with_group(nil)
        end # it

        it 'does not run described bash script' do
          allow_any_instance_of(Pathname).to receive(:directory?)
            .and_return(false)
          expect(chef_run).to_not run_bash(subject)
        end # it
      end # describe

      #-------------------------------------------------------- bash[rpmbuild]
      describe 'rpmbuild' do
        it 'runs described bash script' do
          expect(chef_run).to run_bash(subject).with_user('vagrant')
            .with_group('vagrant').with_environment('HOME' => '/home/vagrant')
        end # it
      end # describe

    end # context
  end # [...].each

end # describe
