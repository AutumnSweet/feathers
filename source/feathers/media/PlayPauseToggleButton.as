/*
Feathers
Copyright 2012-2015 Joshua Tynjala. All Rights Reserved.

This program is free software. You can redistribute and/or modify it in
accordance with the terms of the accompanying license agreement.
*/
package feathers.media
{
	import feathers.controls.ToggleButton;
	import feathers.events.MediaPlayerEventType;
	import feathers.skins.IStyleProvider;

	import starling.events.Event;

	/**
	 * A specialized toggle button that controls whether a media player is
	 * playing or paused.
	 *
	 * @see ../../../help/sound-player.html How to use the Feathers SoundPlayer component
	 * @see ../../../help/video-player.html How to use the Feathers VideoPlayer component
	 */
	public class PlayPauseToggleButton extends ToggleButton implements IMediaPlayerControl
	{
		/**
		 * The default <code>IStyleProvider</code> for all
		 * <code>PlayPauseToggleButton</code> components.
		 *
		 * @default null
		 * @see feathers.core.FeathersControl#styleProvider
		 */
		public static var globalStyleProvider:IStyleProvider;
		
		/**
		 * Constructor.
		 */
		public function PlayPauseToggleButton()
		{
			super();
			//we don't actually want this to toggle automatically. instead,
			//we'll update isSelected based on events dispatched by the media
			//player
			this.isToggle = false;
			this.addEventListener(Event.TRIGGERED, playPlayButton_triggeredHandler);
		}

		/**
		 * @private
		 */
		override protected function get defaultStyleProvider():IStyleProvider
		{
			return PlayPauseToggleButton.globalStyleProvider;
		}

		/**
		 * @private
		 */
		protected var _mediaPlayer:ITimedMediaPlayer;

		/**
		 * @inheritDoc
		 */
		public function get mediaPlayer():IMediaPlayer
		{
			return this._mediaPlayer;
		}

		/**
		 * @private
		 */
		public function set mediaPlayer(value:IMediaPlayer):void
		{
			if(this._mediaPlayer == value)
			{
				return;
			}
			if(this._mediaPlayer)
			{
				this._mediaPlayer.removeEventListener(MediaPlayerEventType.PLAYBACK_STATE_CHANGE, mediaPlayer_playbackStateChangeHandler);
			}
			this._mediaPlayer = value as ITimedMediaPlayer;
			if(this._mediaPlayer)
			{
				this.isSelected = this._mediaPlayer.isPlaying;
				this._mediaPlayer.addEventListener(MediaPlayerEventType.PLAYBACK_STATE_CHANGE, mediaPlayer_playbackStateChangeHandler);
			}
			else
			{
				this.isSelected = false;
			}
			this.invalidate(INVALIDATION_FLAG_DATA);
		}

		/**
		 * @private
		 */
		protected function playPlayButton_triggeredHandler(event:Event):void
		{
			this._mediaPlayer.togglePlayPause();
		}

		/**
		 * @private
		 */
		protected function mediaPlayer_playbackStateChangeHandler(event:Event):void
		{
			this.isSelected = this._mediaPlayer.isPlaying;
		}
	}
}
