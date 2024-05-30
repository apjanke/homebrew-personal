cask 'nheko-reborn' do
  version '0.6.3'
  sha256 'fe6f5effbcca452e09254d1f1eda41fa806449b14cc998332cd98869e5ef0c61'

  url "https://github.com/Nheko-Reborn/nheko/releases/download/v#{version}/nheko-v#{version}.dmg"
  name 'Nheko'
  homepage 'https://github.com/Nheko-Reborn/nheko'

  app 'Nheko.app'
end
