# Vagrant Selenium
A Vagrant Linux environment ready to be used with Selenium.

The base OS is currently Ubuntu 16.04 LTS.

## Introduction

Selenium allows you to automate tests in Web Browsers. To do so, you need to have selenium webdriver installed for all the browsers that you want to run your test into.

## Installation

1. Install [Vagrant](https://www.vagrantup.com)
2. Clone this git repository
3. Run the command `vagrant up`

This vagrant works for *Virtualbox* on a 64 bit machine.

## Browser support

- Firefox (latest version)
- Google Chrome (latest version)

The script also installs the latest version of selenium server and google chrome webdriver.

## Why a VM for Selenium?

Installing selenium server and webdrivers is not complicated. However, to have consistent repeatable tests by multiple users they need to be run in the exact same browser, operating system, and screen resolution.  This allows your tests to be perfectly repeatable in an isolated environment.

## How does it work?

When the VM starts, it automatically runs selenium server, along with the google-chrome webdriver. **You need to wait a few minutes** before running your tests.

On your host machine, you can send the tests to selenium server's default **port 4444** at this vagrant's IP, which is currently assigned dynamically.
