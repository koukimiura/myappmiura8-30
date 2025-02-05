class EventsController < ApplicationController
    before_action :authenticate_user!, :only => [:new, :show, :create, :edit, :update, :destroy]
    before_action :ensure_correct_user, :only => [:edit, :update, :destroy]
    before_action :forbid_login_user, only: [:show, :new, :create, :edit, :update, :destroy]
    
    def index
        @events = Event.all.order(created_at: :desc)
    end
    
    def show
        @event = Event.find(params[:id])
        @like = Like.new
        @like_count = Like.where(event_id: @event.id).count
        @message = Message.new
        @messages = Message.where(event_id: @event.id)
    end
    
    def new
        @event = Event.new
    end
    
    def create
        @event = Event.new(event_params)
            if @event.save
                flash[:notice] = '投稿しました。'
                redirect_to events_path
            else
                flash.now[:alert] = '投稿できませんでした。'
                render 'events/new'
            end
    end
    
    def edit 
         @event = Event.find(params[:id])
    end
    
    def update
         @event = Event.find(params[:id])
            if @event.update(event_params)
                flash[:notice] = 'イベントを編集しました。'
                redirect_to events_path
            else
                flash.now[:alert] = '投稿できませんでした。'
                render 'events/edit'
            end
    end
    

    def destroy
         @event = Event.find(params[:id])
         @event.destroy
         redirect_to events_path
    end
    
    
    def ensure_correct_user
        @event = Event.find(params[:id])
            if @event.user_id != current_user.id
                flash[:notice] = "権限はありません"
                redirect_to :back
            end
    end
    
    
    def event_params
        params.require(:event).permit(:title, :content, :image, :location, :user_id).merge(:user_id => current_user.id)
    end
end
