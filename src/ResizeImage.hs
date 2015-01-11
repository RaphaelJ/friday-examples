{-# LANGUAGE ScopedTypeVariables #-}
import System.Environment (getArgs)

import Vision.Image
import Vision.Image.Storage.DevIL (Autodetect (..), load, save)
import Vision.Primitive (ix2)

-- Resizes the input image to a square of 250x250 pixels.
--
-- usage: ./resize_image input.png output.png
main :: IO ()
main = do
    [input, output] <- getArgs

    -- Loads the image. Automatically infers the format.
    io <- load Autodetect input

    case io of
        Left err           -> do
            putStrLn "Unable to load the image:"
            print err
        Right (rgb :: RGB) -> do
            let -- Resizes the RGB image to 250x250 pixels.
                resized = resize Bilinear (ix2 250 250) rgb :: RGB

            -- Saves the resized image. Automatically infers the output format.
            mErr <- save Autodetect output resized
            case mErr of
                Nothing  ->
                    putStrLn "Success."
                Just err -> do
                    putStrLn "Unable to save the image:"
                    print err
