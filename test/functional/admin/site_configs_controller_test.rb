require 'test_helper'

class Admin::SiteConfigsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:admin_site_configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create site_config" do
    assert_difference('Admin::SiteConfig.count') do
      post :create, :site_config => { }
    end

    assert_redirected_to site_config_path(assigns(:site_config))
  end

  test "should show site_config" do
    get :show, :id => admin_site_configs(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => admin_site_configs(:one).to_param
    assert_response :success
  end

  test "should update site_config" do
    put :update, :id => admin_site_configs(:one).to_param, :site_config => { }
    assert_redirected_to site_config_path(assigns(:site_config))
  end

  test "should destroy site_config" do
    assert_difference('Admin::SiteConfig.count', -1) do
      delete :destroy, :id => admin_site_configs(:one).to_param
    end

    assert_redirected_to admin_site_configs_path
  end
end
