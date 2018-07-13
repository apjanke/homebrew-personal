cask 'intellij-idea-ce' do
  version '2016.1.2b'
  sha256 '21d2a850ac5da0dfa0197cee85b31d797136629d82cc84d914ca91d503c1d0a1'

  url "https://download.jetbrains.com/idea/ideaIC-#{version}.dmg"
  name 'IntelliJ IDEA Community Edition'
  homepage 'https://www.jetbrains.com/idea/'

  conflicts_with cask: 'intellij-idea'

  app 'IntelliJ IDEA CE.app'

  uninstall delete: '/usr/local/bin/idea'

  zap delete: [
                "~/.IntelliJIdea#{version.major_minor}",
                "~/Library/Caches/IntelliJIdea#{version.major_minor}",
                "~/Library/Logs/IntelliJIdea#{version.major_minor}",
                "~/Library/Application Support/IntelliJIdea#{version.major_minor}",
                "~/Library/Preferences/IntelliJIdea#{version.major_minor}",
              ]
end
