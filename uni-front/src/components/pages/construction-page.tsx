import Image from "next/image";
import React from "react";
interface Props {
  title: string;
}
const ConstructionPage = ({ title }: Props) => {
  return (
    <div className="flex flex-col items-center justify-center">
      <Image
        src={"/dev.svg"}
        alt="Developer"
        width={550}
        height={550}
        className="px-5 mx-5"
      />
      <section className="text-center mt-5">
        <h1 className="text-4xl font-bold">{title} en Construcción</h1>
        <p>Estamos trabajando en la página. ¡Vuelve pronto!</p>
      </section>
    </div>
  );
};

export default ConstructionPage;
