{-# LANGUAGE ScopedTypeVariables #-}
import System.Environment (getArgs)

import Vision.Image
import Vision.Image.Storage.DevIL (Autodetect (..), load, save)
import Vision.Primitive (ix2)

-- Thresholds an image by applying the SCW method.
--
-- usage: ./scw .png output.png
main :: IO ()
main = do
    [input, output] <- getArgs

    -- Loads the image. Automatically infers the format.
    io <- load Autodetect input

    case io of
        Left err             -> do
            putStrLn "Unable to load the image:"
            print err
        Right (grey :: Grey) -> do
            let thresholded :: Grey
                thresholded = scw (ix2 5 5) (ix2 15 15) (5 :: Double)
                                  (BinaryThreshold 255 0) grey

            -- Saves the thresholded image. Automatically infers the output
            -- format.
            mErr <- save Autodetect output thresholded
            case mErr of
                Nothing  ->
                    putStrLn "Success."
                Just err -> do
                    putStrLn "Unable to save the image:"
                    print err
