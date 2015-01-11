{-# LANGUAGE ScopedTypeVariables #-}
import Prelude hiding (filter)
import System.Environment (getArgs)

import Vision.Detector.Edge (canny)
import Vision.Image
import Vision.Image.Storage.DevIL (Autodetect (..), load, save)

-- Detects the edge of the image with the Canny's edge detector.
--
-- usage: ./canny input.png output.png
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
            let blurred, edges :: Grey
                -- Applies a Gaussian filter with a 3x3 Double kernel to remove
                -- small noises.
                blurred = gaussianBlur 1 (Nothing :: Maybe Double) grey

                -- Applies the Canny's algorithm with a 5x5 Sobel kernel (radius
                -- = 2).
                edges = canny 2 256 1024 blurred

            -- Saves the edges image. Automatically infers the output format.
            mErr <- save Autodetect output edges
            case mErr of
                Nothing  ->
                    putStrLn "Success."
                Just err -> do
                    putStrLn "Unable to save the image:"
                    print err
