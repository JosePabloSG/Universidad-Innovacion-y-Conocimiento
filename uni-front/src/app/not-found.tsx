import Link from 'next/link'
import Image from 'next/image'
import { Button } from "@/components/ui/button"
import { MoveLeft } from "lucide-react"

export default function NotFound() {
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-background text-foreground p-20">
      <div className="w-full max-w-md space-y-8 text-center ">
        <div className="mx-auto w-full h-full mb-4 ">  
        <Image 
            src="/not-found.svg"  
            alt="Not Found"
            width={98}  
            height={98} 
            className="w-full h-full text-primary "
          />
        </div>
        <p className="max-w-[42rem] leading-normal text-muted-foreground  sm:text-2xl sm:leading-8">
          Lo sentimos, no pudimos encontrar la página que estás buscando.
        </p>
        <div className="flex justify-center mt-8">
          <Button asChild>
            <Link href="/">
              <MoveLeft className="mr-2 h-4 w-4" />
              Volver al inicio
            </Link>
          </Button>
        </div>
      </div>
      <div className="mt-16 w-full max-w-2xl">
        <div className="relative w-full h-48">
        </div>
      </div>
    </div>
  )
}
