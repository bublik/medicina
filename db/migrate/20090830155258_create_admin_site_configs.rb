class CreateAdminSiteConfigs < ActiveRecord::Migration
  def self.up
    create_table :site_configs do |t|
      t.text :body
      t.string :identifier
      t.boolean :is_active,  :default => true
      t.date :disable_at

      t.timestamps
    end

    SiteConfig.create_translation_table!(:body => :text)
    
    say("Start translation Posts[#{I18n.locale}]")

    { 'frends' => '<!-- Add your frends there -->',
      'after_head' => '<!-- after head -->',
      'advert_after_post' => '<!-- advert after post -->',
      'before_container' => '<!-- before_container -->',
      'before_footer' => '<!-- before_footer -->',
      'after_post_attachments' => '<!-- after_post_attachments -->',
      'counter_buttons' => '<!-- counters -->',
      'google_horizontal_advert' =>
        '<script type="text/javascript"><!--
google_ad_client = "pub-1004778522513778";
/* 728x15, создано 19.06.09 */
google_ad_slot = "1745993584";
google_ad_width = 728;
google_ad_height = 15;
//-->
</script>
<script type="text/javascript"
src="http://pagead2.googlesyndication.com/pagead/show_ads.js">
</script>',
      'google_block_advert' =>
        '',
      'footer_google_search_form' =>
        '',

      'header_google_search_form' =>
        ''
    }.each do |identifier, body|
      conf = SiteConfig.find_or_create_by_identifier(identifier)
      conf.body = body
      if conf.save
        say("locale: #{I18n.locale}\n identifier:#{identifier}\n----------\n")
      end
    end
  end

  def self.down
    SiteConfig.drop_translation_table!
    drop_table :site_configs
  end
end
