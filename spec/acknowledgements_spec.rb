describe Fastlane::Actions::AcknowledgementsAction do
  describe '#run' do
    it 'Creates a set of acknowledgements files' do
      allow(Fastlane::UI).to receive(:success)
      expect(Fastlane::UI).to receive(:success).with('Acknowledgement Generator Finished')

      Fastlane::Actions::AcknowledgementsAction.run(
        settings_bundle: 'example-project/settings.bundle',
        license_path: 'example-project/licenses'
      )
    end
  end
end
