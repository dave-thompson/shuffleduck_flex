package com.mindegg.theme.skins
{
    import mx.skins.RectangularBorder;
    import flash.display.Graphics;
    import mx.graphics.RectangularDropShadow;

    public class CustomSkinThumb extends RectangularBorder
    {

        private var dropShadow:RectangularDropShadow;

        override protected function updateDisplayList 
        (unscaledWidth:Number, unscaledHeight:Number):void 
        {
        	//unscaledWidth = 45;
        	unscaledWidth = 10;
        	//unscaledHeight = unscaledHeight/2;
        	//unscaledHeight = 50;

            super.updateDisplayList(unscaledWidth, unscaledHeight);
            var cornerRadius:Number = getStyle("cornerRadius");
            var backgroundColor:int = 0x3D464B;
            var backgroundAlpha:Number = 1.0;
            graphics.clear();
            
            // Background
      		//this.x = -15;
      		this.x = -5;

            drawRoundRect
            (
                0, 0, unscaledWidth, unscaledHeight, 
                {tl: 0, tr: cornerRadius, bl: 0, br: cornerRadius}, 
                backgroundColor, backgroundAlpha
            );
            
            // Shadow

            if (!dropShadow)
                dropShadow = new RectangularDropShadow();
            
            dropShadow.distance = 5;
            dropShadow.angle = 0;
            dropShadow.color = 0;
            dropShadow.alpha = 0.4;
            dropShadow.tlRadius = 0;
            dropShadow.trRadius = cornerRadius;
            dropShadow.blRadius = 0;
            dropShadow.brRadius = cornerRadius;
            
            dropShadow.drawShadow(graphics, 0, 0, unscaledWidth, unscaledHeight);
        }

    }
}
