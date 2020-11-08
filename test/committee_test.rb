# frozen_string_literal: true

require "test_helper"

describe Committee do
  it "debugs based off env" do
    old = ENV["COMMITTEE_DEBUG"]
    begin
      ENV["COMMITTEE_DEBUG"] = nil
      refute Committee.debug?
      ENV["COMMITTEE_DEBUG"] = "true"
      assert Committee.debug?
    ensure
      ENV["COMMITTEE_DEBUG"] = old
    end
  end

  it "logs debug messages to stderr" do
    old_stderr = $stderr
    $stderr = StringIO.new
    begin
      stub(Committee).debug? { false }
      Committee.log_debug "blah"
      assert_equal "", $stderr.string

      stub(Committee).debug? { true }
      Committee.log_debug "blah"
      assert_equal "blah\n", $stderr.string
    ensure
      $stderr = old_stderr
    end
  end

  it "warns on deprecated unless $VERBOSE is nil" do
    old_stderr = $stderr
    old_verbose = $VERBOSE
    $stderr = StringIO.new
    begin
      $VERBOSE = nil
      Committee.warn_deprecated "blah"
      assert_equal "", $stderr.string

      $VERBOSE = true
      Committee.warn_deprecated "blah"
      assert_equal "[DEPRECATION] blah\n", $stderr.string
    ensure
      $stderr = old_stderr
      $VERBOSE = old_verbose
    end
  end
end
